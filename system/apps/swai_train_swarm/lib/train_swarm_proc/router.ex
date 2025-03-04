defmodule TrainSwarmProc.Router do
  use Commanded.Commands.Router

  alias TrainSwarmProc.Aggregate, as: Aggregate

  alias TrainSwarmProc.InitializeLicense.CmdV1, as: InitializeLicense
  alias TrainSwarmProc.InitializeLicense.Evaluator, as: InitializeLicenseHandler

  alias TrainSwarmProc.ConfigureLicense.CmdV1, as: ConfigureLicense
  alias TrainSwarmProc.ConfigureLicense.Evaluator, as: ConfigureLicenseHandler

  alias TrainSwarmProc.PayLicense.CmdV1, as: PayLicense
  alias TrainSwarmProc.PayLicense.Evaluator, as: PayLicenseHandler

  alias TrainSwarmProc.PauseLicense.CmdV1, as: PauseLicense
  alias TrainSwarmProc.PauseLicense.Evaluator, as: PauseLicenseHandler

  alias TrainSwarmProc.ActivateLicense.CmdV1, as: ActivateLicense
  alias TrainSwarmProc.ActivateLicense.Evaluator, as: ActivateLicenseHandler

  alias TrainSwarmProc.QueueLicense.CmdV1, as: QueueLicense
  alias TrainSwarmProc.QueueLicense.Evaluator, as: QueueLicenseHandler

  alias TrainSwarmProc.ReserveLicense.CmdV1, as: ReserveLicense
  alias TrainSwarmProc.ReserveLicense.Evaluator, as: ReserveLicenseHandler

  alias TrainSwarmProc.StartLicense.CmdV1, as: StartLicense
  alias TrainSwarmProc.StartLicense.Evaluator, as: StartLicenseHandler

  dispatch(InitializeLicense,
    to: InitializeLicenseHandler,
    aggregate: Aggregate,
    identity: :agg_id
  )

  dispatch(ConfigureLicense,
    to: ConfigureLicenseHandler,
    aggregate: Aggregate,
    identity: :agg_id
  )

  dispatch(PayLicense,
    to: PayLicenseHandler,
    aggregate: Aggregate,
    identity: :agg_id
  )

  dispatch(ActivateLicense,
    to: ActivateLicenseHandler,
    aggregate: Aggregate,
    identity: :agg_id
  )

  dispatch(QueueLicense,
    to: QueueLicenseHandler,
    aggregate: Aggregate,
    identity: :agg_id
  )

  dispatch(StartLicense,
    to: StartLicenseHandler,
    aggregate: Aggregate,
    identity: :agg_id
  )

  dispatch(PauseLicense,
    to: PauseLicenseHandler,
    aggregate: Aggregate,
    identity: :agg_id
  )

  dispatch(ReserveLicense,
    to: ReserveLicenseHandler,
    aggregate: Aggregate,
    identity: :agg_id
  )
end
